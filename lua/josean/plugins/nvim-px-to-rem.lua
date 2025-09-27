return {
  "jsongerber/nvim-px-to-rem",
  config = function()
    require("nvim-px-to-rem").setup({
      root_font_size = 16,
      decimal_count = 4,
      show_virtual_text = true,
      add_cmp_source = true,
    })

    vim.keymap.set("n", "<leader>pxx", ":PxToRemCursor<CR>", { desc = "Px to rem cursor", noremap = true })
    vim.keymap.set("n", "<leader>pxl", ":PxToRemLine<CR>", { desc = "Px to rem line", noremap = true })
    vim.keymap.set("v", "<leader>px", ":PxToRemLine<CR>", { desc = "Px to rem selection", noremap = true })
  end,
}
