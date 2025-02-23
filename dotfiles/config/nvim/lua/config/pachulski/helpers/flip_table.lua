local function flip_table(table)
  local flipped = {}
  for key, values in pairs(table) do
    for _, value in ipairs(values) do
      flipped[value] = { key }
    end
  end
  return flipped
end

return flip_table
