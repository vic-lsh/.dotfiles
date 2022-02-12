require('telescope').setup{
    file_ignore_patterns = {
        "./node_modules/*",
        "node_modules",
        "^node_modules/*",
        "node_modules/*",
        ".git/",
        ".cache",
        "%.o",
        "%.a",
        "%.out",
        "%.class",
        "%.pdf",
        "%.mkv",
        "%.mp4",
        "%.zip"
    },
}
