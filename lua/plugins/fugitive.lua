--[[
    Copyright 2023 Oscar Wallberg

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
]]

-- https://github.com/tpope/vim-fugitive

local function git_status_tab()
    vim.cmd.tabnew()
    vim.cmd("leftabove vertical G")
    vim.cmd("vertical resize 60")
    vim.cmd.set("wfw")
end

vim.keymap.set("n", "<leader>gd", vim.cmd.Gdiffsplit)
vim.keymap.set("n", "<leader>gc", function () vim.cmd.G("commit") end)
vim.keymap.set("n", "<leader>ga", function () vim.cmd.G("commit --amend") end)

-- Only used if diffview is not available
if not pcall(require, "diffview") then
    vim.keymap.set("n", "<leader>gg", git_status_tab)
end
