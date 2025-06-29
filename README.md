# mpe-extend-table

mpe-extend-table is a Pandoc Lua filter that adds support for [Markdown Preview Enhanced (MPE)'s extended table syntax](https://shd101wyy.github.io/markdown-preview-enhanced/#/markdown-basics?id=table) in Pandoc workflows.

## Features

- Parses and expands MPE-style extended table syntax
- Supports merged cells (both horizontal and vertical)
  - `>` (merge right)
  - `^` (merge up)
- Seamless integration with Pandoc’s native table AST
- Compatible with LaTeX, HTML, and PDF backends

## Installation

Clone the repository and copy `mpe_extend_table.lua` to your working directory or to your filters directory

## Usage

Include the Lua filter when running Pandoc:

```bash
pandoc input.md -o output.pdf --lua-filter=mpe_extend_table.lua
```

## License

This project is licensed under the MIT License.

## Contributing

Contributions, bug reports, and feature requests are welcome! Feel free to open an issue or submit a pull request.
