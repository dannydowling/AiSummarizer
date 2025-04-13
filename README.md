# File Collector

A high-performance C++ utility for collecting source code from projects to provide comprehensive context for AI code analysis.

## Overview

File Collector recursively traverses directories to gather all source code files into a single consolidated output file. This makes it easier to provide complete project context when working with large codebases and AI assistants like Claude.

Key features:
- Multi-threaded processing using Boost for maximum performance
- Prioritizes important files like solution files, project files, and READMEs
- Preserves file structure with clear file separators
- Skips binary files, build directories, and other non-relevant content
- Works well with Visual Studio and other types of projects

## Use Cases

- Providing complete project context to AI assistants
- Creating comprehensive documentation of a codebase
- Preparing codebases for auditing or review
- Analyzing and understanding large, complex projects

## Requirements

- C++17 compatible compiler (Visual Studio 2019+, GCC 8+, or Clang 7+)
- Boost libraries (thread, system, asio)
- CMake 3.10+ (optional, for easier building)

## Installation

### From Source

1. Clone the repository:
   ```
   git clone https://github.com/dannydowling/AiSummarizer.git
   cd AiSummarizer
   ```

2. Build with CMake:
   ```
   mkdir build
   cd build
   cmake ..
   cmake --build .
   ```

3. Or build with Visual Studio:
   - Open the solution file in Visual Studio
   - Build the solution (F7)

### Build Requirements

Make sure you have Boost installed:

- **Windows**: Download from [boost.org](https://www.boost.org/users/download/) and build with `bootstrap.bat` and `b2`
- **macOS**: `brew install boost`
- **Linux**: `sudo apt-get install libboost-all-dev` or equivalent

## Usage

```
FileCollector [source_directory] [output_file]
```

### Parameters:

- `source_directory`: Optional. The directory to scan for files. Defaults to the current directory.
- `output_file`: Optional. The file to write the collected content to. Defaults to `all_codebase_files.txt` in the source directory.

### Examples:

```
# Process current directory
FileCollector

# Process specific directory
FileCollector C:\Projects\MyProject

# Process specific directory with custom output file
FileCollector C:\Projects\MyProject C:\output\project_context.md
```

## Configuration

The utility comes with sensible defaults, but you can modify these in the source code:

- **Text file extensions**: Edit the `text_extensions` set in FileCollector.cpp
- **Excluded directories**: Edit the `exclude_dirs` set to skip additional directories
- **Priority files**: Edit the `priority_patterns` vector to change which files are processed first

## Performance

The application is optimized for performance with:
- Multi-threaded file processing using Boost thread pool
- Efficient filesystem operations
- Thread-safe string building
- Prioritized file processing order

For large codebases, this implementation is significantly faster than single-threaded alternatives, with processing times often reduced by 70-80% on multi-core systems.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- The Boost community for their excellent libraries
- Anthropic's Claude for assistance in refining the codebase

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
