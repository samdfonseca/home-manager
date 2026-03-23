-- if true then return {} end

---@type LazySpec
return {
  "Civitasv/cmake-tools.nvim",
  opts = function(_, opts)
    opts.cmake_build_directory = function() return "build/${variant:buildType}" end
  end,
}
