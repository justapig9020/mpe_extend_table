local CellType = {
	Normal = 0,
	MergeRight = 1,
	MergeUp = 2,
}

local CellTypeName = {
	[0] = "Normal",
	[1] = "MergeRight",
	[2] = "MergeUp",
}

local MERGE_RIGHT = { pandoc.Plain({ pandoc.Str(">") }) }
local MERGE_UP = { pandoc.Plain({ pandoc.Str("^") }) }

local function deep_equal(a, b)
	if type(a) ~= type(b) then
		return false
	end

	if type(a) ~= "table" then
		return a == b
	end

	if a.t and b.t and a.t ~= b.t then
		return false
	end

	for k, v in pairs(a) do
		if not deep_equal(v, b[k]) then
			return false
		end
	end
	for k, v in pairs(b) do
		if not deep_equal(v, a[k]) then
			return false
		end
	end

	return true
end

local function parse_cell_type(cell)
	local conditions = {
		[CellType.MergeRight] = MERGE_RIGHT,
		[CellType.MergeUp] = MERGE_UP,
	}

	for cell_type, reference in pairs(conditions) do
		if deep_equal(cell.contents, reference) then
			return cell_type
		end
	end

	return CellType.Normal
end

local function init_nil_array(n)
	local array = {}
	for _ = 1, n, 1 do
		table.insert(array, nil)
	end
	return array
end

local function Table(ast)
	local n_cols = #ast.colspecs
	for _, tablebody in ipairs(ast.bodies) do
		local prev_row = init_nil_array(n_cols)
		for _, row in ipairs(tablebody.body) do
			local merged_cols = 0
			local updated_cells = {}
			for col, cell in ipairs(row.cells) do
				local cell_type = parse_cell_type(cell)
				if CellType.MergeRight == cell_type then
					merged_cols = merged_cols + cell.col_span
					prev_row[col] = nil
				elseif CellType.Normal == cell_type then
					cell.col_span = cell.col_span + merged_cols
					merged_cols = 0
					table.insert(updated_cells, cell)
					prev_row[col] = cell
				elseif CellType.MergeUp == cell_type then
					local target = prev_row[col]
					if target then
						target.row_span = target.row_span + cell.row_span
					end
				end
			end
			row.cells = updated_cells
		end
	end
	return ast
end

return { { Table = Table } }
