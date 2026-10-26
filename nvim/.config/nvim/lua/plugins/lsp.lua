return {
  -- Configure qmlls in lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          cmd = { "qmlls", "-E" },
          filetypes = { "qml" },
        },
      },
    },
  },

  -- Automatically install QML syntax parser for Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "qmljs" })
      end
    end,
  },
}
