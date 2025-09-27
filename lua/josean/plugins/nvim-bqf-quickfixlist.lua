return {
  "kevinhwang91/nvim-bqf",
  config = function()
    local bqf = require("bqf")

    bqf.setup({
      preview = {
        auto_preview = false,
      },
      func_map = {
        open = "o",
        openc = "O",

        tabdrop = "",
        tabc = "",
        tab = "",
        tabb = "",

        ptogglemode = "z,",
        filter = "zn",
        filterr = "zN",

        stoggledown = "<C-y>",
        stogglevm = "<C-y>",
      },
    })

    vim.api.nvim_create_user_command("CdoMacro", function(opts)
      local register = opts.args
      vim.cmd('cdo execute "norm! @' .. register .. '" | update')
    end, { nargs = 1 })

    vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Go to next quickfix", silent = true, noremap = true })
    vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Go to prev quickfix", silent = true, noremap = true })
    vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix list" })
    vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Go to prev quickfix", silent = true, noremap = true })
  end,
}
