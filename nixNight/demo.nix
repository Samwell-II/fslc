#======= opperations =======

3+7
3*7
3-7 # Works because 3-7 isn't an identifier. a-7 does not work.
3/7 # Not what you'd expect.
3 / 7
builtins.div 3 7


#======= types ========

true
7.02
"Hello"
./this/is/a/path
/abosolute/works/too

#======= structures =========

["lists" 7 true []]
{
  hey="YOU";
  yup=1;
  "stuff"=true;
  more={
    layers=9001;
  };
  lots.at.once=":)";
  lots.at.twice=":D";
}

#======= control ========

if 1>2 then "big" else "small"
let x = 6; in if x / 2 == 3 then x else "not six"

let
  attributeSet = {
    a = 1;
    b = 2;
    c = 3;
  };
in with attributeSet; a*a + b*b + c*c

#======= functions ========

# argument: result

x: x*2
y: (x: x*y)
s: s.a * s.b
{a, b}: a * b
{a, b ? 6, ...}: a * b

