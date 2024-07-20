SELECT X,Y,Z,
case when x+y>z and y+z>x and x+z>y then 'YES' else 'NO' end
from triangle
order by x,y,z