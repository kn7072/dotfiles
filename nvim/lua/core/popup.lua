-- Создаем новые пункты контекстного меню (нажатие правой кнопки мыши)
vim.cmd('menu PopUp.-Sep- :') -- нарисует разделительную линию вместо обычного пункта
vim.cmd(
    'menu PopUp.Continue <Cmd>lua local dap = require "dap"; dap.continue()<CR>')
vim.cmd(
    'menu PopUp.Breakpoint <Cmd> lua local dap = require "dap"; dap.set_breakpoint()<CR>')
vim.cmd(
    'menu PopUp.Toggle\\ breakpoint <Cmd> lua local dap = require "dap"; dap.toggle_breakpoint()<CR>')
vim.cmd(
    'menu PopUp.Condition\\ breakpoint <Cmd> lua local dap = require "dap"; dap.set_breakpoint(vim.fn.input("condition: "))')

