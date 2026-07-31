local t = require("tests.helpers")

t.describe("xeno export command", function()
  t.it("prompts the user and exports with the custom name", function()
    t.reset_state()
    local xeno = require("xeno")
    xeno.setup(t.test_config({}))

    -- Mock vim.ui.input
    local captured_callback = nil
    vim.ui.input = function(opts, callback)
      captured_callback = callback
    end

    local exported_path = nil
    local mock_notify = vim.notify
    vim.notify = function(msg)
      if msg:find("Theme exported to: ") then
        exported_path = msg:sub(19)
      end
    end

    -- Run the command
    require("xeno.export.init_cmd").export()
    
    -- Simulate user input
    captured_callback("my-theme")

    t.truthy(exported_path:find("my%-theme%.lua$"), "File should be renamed to my-theme.lua (exported_path: " .. tostring(exported_path) .. ")")
    t.truthy(vim.fn.filereadable(exported_path), "Exported file should exist")

    -- Clean up
    vim.notify = mock_notify
    os.remove(exported_path)
  end)
end)
