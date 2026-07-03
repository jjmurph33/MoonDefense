local Util = {}

function Util.off_screen(rect)
  return rect.x + rect.w < 0 or rect.x > usagi.GAME_W or rect.y + rect.h < 0 or rect.y > usagi.GAME_H
end

return Util
