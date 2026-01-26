return {
    "3rd/image.nvim",
    opts = {
        integrations = {
            editor = {
                enable = true,
            },
        },

        hijack_file_patterns = {
            "*.png",
            "*.jpg",
            "*.jpeg",
            "*.gif",
            "*.webp",
            "*.ico",
        },
    },
}
