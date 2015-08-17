function math.sign(x) return x > 0 and 1 or x < 0 and -1 or 0 end
function math.round(x) return math.sign(x) >= 0 and math.floor(x + .5) or math.ceil(x - .5) end