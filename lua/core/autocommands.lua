vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.wo.number = true
        vim.wo.relativenumber = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Use tabs for indents in Go files",
    pattern = "go",
    callback = function()
        vim.bo.expandtab = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Fix parsing compile errors into quickfixlist",
    pattern = "zig",
    callback = function()
        vim.bo.errorformat = "%f:%l:%c: %t%.%#: %m,%-G%.%#"
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    desc = "Return cursor to last position when re-opening a buffer",
    pattern = "*",
    command = 'silent! normal! g`"zv',
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Use two space indent for C++ files",
    pattern = { "cpp" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.cinoptions = "g0"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "netrw" },
    callback = function()
        vim.keymap.set("n", "<C-h>", "-", { buffer = true, remap = true })
        vim.keymap.set("n", "<C-l>", "<CR>", { buffer = true, remap = true })
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = ":clearjumps",
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Make markdown files a bit prettier",
    pattern = { "markdown" },
    callback = function()
        vim.wo.conceallevel = 2
        vim.wo.concealcursor = "n"
    end,
})

local make_group = vim.api.nvim_create_augroup("make_diagnostics", {})
local make_namespace = vim.api.nvim_create_namespace("make_diagnostics")
-- Create diagnostics after running :make
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    callback = function(ctx)
        if ctx.match ~= "make" then
            return
        end

        local diagnostics = vim.diagnostic.fromqflist(vim.fn.getqflist())
        local buf_diag = {}
        for _, d in ipairs(diagnostics) do
            if not d.bufnr then
                goto continue
            end

            if not buf_diag[d.bufnr] then
                buf_diag[d.bufnr] = {}
            end

            table.insert(buf_diag[d.bufnr], d)

            ::continue::
        end

        for bufnr, d in pairs(buf_diag) do
            vim.diagnostic.set(make_namespace, bufnr, d)
        end
    end,
    group = make_group,
})
-- Clear old make diagnostics before running :make
vim.api.nvim_create_autocmd("QuickFixCmdPre", {
    callback = function(ctx)
        if ctx.match ~= "make" then
            return
        end

        local diagnostics = vim.diagnostic.fromqflist(vim.fn.getqflist())
        local bufs = {}
        for _, d in ipairs(diagnostics) do
            if d.bufnr then
                table.insert(bufs, d.bufnr)
            end
        end

        for _, bufnr in ipairs(bufs) do
            vim.diagnostic.reset(make_namespace, bufnr)
        end
    end,
    group = make_group,
})
