local M = {}

M.COLORS = {
  amber = "#ffbf00",
  dark_blue = "#104060",
  gray = "#232323",
  black = "#000000",
  white = "#ffffff",
  purple = "#810CA8",
  red = "#750E21",
  bloodOrange = "#ff4300",
  -- rosepine = "#211b29",
  rosepine = "#191724",

  nordic_black = "#191D24",
  nordic_gray1 = "#2E3440",
  nordic_fg_bright = "#D8DEE9",

  nightfly_blue = "#011627",
}

-- TODO: create palette
M.palette = {
  status_bar = {
    bg = M.COLORS.nordic_black,
  },
  background = M.COLORS.nightfly_blue,
}

return M
