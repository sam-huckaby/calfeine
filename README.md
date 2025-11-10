# Calfeine

A simple, fast OCaml web server built with Eio that only serves designated files.

## Features

- **Allowlist-based serving**: Only files listed in `files.site` are served
- **File type restrictions**: Only `.html`, `.ico`, and `.png` files allowed
- **Eio-powered**: Uses modern effects-based concurrency for high performance
- **Simple configuration**: Plain text newline-separated list of files allowed to be served
- **Automatic 404s**: Any unlisted file returns 404 Not Found

## Installation

### Prerequisites

- OCaml 5.0 or later (for effects support)
- opam package manager

### Build from source

```bash
# Install dependencies
opam install . --deps-only

# Build the project
dune build

# Install the executable
dune install
```

## Usage

### Basic usage

```bash
# Start the server (default: port 8080, allowed files: files.site)
calfeine

# Custom port
calfeine -p 3000

# Custom list of allowed files
calfeine -f myfiles.list
```

### Creating the list of files to serve

Create a `files.site` file in your project directory:

```
# List files to serve, one per line
# Comments start with #
index.html
about.html
favicon.ico
logo.png
```

**Important**: Only files with `.html`, `.ico`, or `.png` extensions will be served, even if listed in our file list.

### Example

```bash
# Create your list of files to serve
echo "index.html" > files.site
echo "logo.png" >> files.site

# Create your files
echo "<h1>Hello, Calfeine!</h1>" > index.html

# Start the server
calfeine

# Visit http://127.0.0.1:8080
```

## How it works

1. Server reads `files.site` on startup and loads allowed filenames
2. Only files with `.html`, `.ico`, or `.png` extensions are allowed
3. Each HTTP request is checked against the list of allowed files
4. If the file is allowed and exists, it's served with proper MIME type
5. Otherwise, returns 404 Not Found

## Security

- **No directory traversal**: Paths are validated before serving
- **Explicit allow**: Files must be explicitly listed to be served
- **Extension validation**: Only approved file types are served
- **No SSL/TLS yet**: This is an HTTP-only server (for now)

## Development

```bash
# Run in development
dune exec calfeine

# Run tests (when available)
dune test

# Clean build artifacts
dune clean
```

## Why "Calfeine"?

A playful name combining "OCaml" and "caffeine" - because this server is lightweight and gives your web serving a boost!

## License

MIT
