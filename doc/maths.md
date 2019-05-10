## `sugar. maths`

- Contents:
  - [`cos(a)`](#sugarmaths-cos-a)
  - [`sin(a)`](#sugarmaths-sin-a)
  - [`atan2(x, y)`](#sugarmaths-atan2-x-y)
  - [`lerp(a, b, i)`](#sugarmaths-lerp-a-b-i)
  - [`flr(a)`](#sugarmaths-flr-a)
  - [`ceil(a)`](#sugarmaths-ceil-a)
  - [`round(a)`](#sugarmaths-round-a)
  - [`sgn(a)`](#sugarmaths-sgn-a)
  - [`sqr(a)`](#sugarmaths-sqr-a)
  - [`cub(a)`](#sugarmaths-cub-a)
  - [`pow(a, b)`](#sugarmaths-pow-a-b)
  - [`sqrt(a)`](#sugarmaths-sqrt-a)
  - [`abs(a)`](#sugarmaths-abs-a)
  - [`min(a, b)`](#sugarmaths-min-a-b)
  - [`max(a, b)`](#sugarmaths-max-a-b)
  - [`mid(a, b, c)`](#sugarmaths-mid-a-b-c)
  - [`angle_diff(a1, a2)`](#sugarmaths-angle_diff-a1-a2)
  - [`dist(x1, y1, x2, y2)`](#sugarmaths-dist-x1-y1-x2-y2)
  - [`sqrdist(x, y)`](#sugarmaths-sqrdist-x-y)
  - [`srand(seed)`](#sugarmaths-srand-seed)
  - [`raw_rnd()`](#sugarmaths-raw_rnd-)
  - [`rnd(n)`](#sugarmaths-rnd-n)
  - [`irnd(n)`](#sugarmaths-irnd-n)
  - [`pick(tab)`](#sugarmaths-pick-tab)

&#8202;

Angles in sugarcoat are turn-based, where 1 indicates a full turn. 1 is the equivalent of 360 degrees or 2&#960; radians. [More info here.](https://trasevol.dog/2017/06/08/doodle-insights-17-a-case-for-turn-based-angles/)

&#8202;

#### `sugar.maths. cos (a)`
- Returns the cosine of `a` as a turn-based angle.

&#8202;

#### `sugar.maths. sin (a)`
- Returns the sine of `a` as a turn-based angle.

&#8202;

#### `sugar.maths. atan2 (x, y)`
- Converts {`x`; `y`} as an angle from 0 to 1. Returns that angle.

&#8202;

---

#### `sugar.maths. lerp (a, b, i)`
- Returns the linear interpolation from `a` to `b` with the parameter `i`.
- For the intended use, `i` should be between `0` and `1`. However it is not limited to those value.

&#8202;

#### `sugar.maths. flr (a)`
- Returns the closest integer that is equal or below `a`.

&#8202;

#### `sugar.maths. ceil (a)`
- Returns the closest integer that is equal or above `a`.

&#8202;

#### `sugar.maths. round (a)`
- Returns the closest integer to `a`.

&#8202;

#### `sugar.maths. sgn (a)`
- Returns `1` if `a` is positive.
- Returns `-1` if `a` is negative.
- Returns `0` if `a` is zero.

&#8202;

#### `sugar.maths. sqr (a)`
- Returns `a * a`.

#### `sugar.maths. cub (a)`
- Returns `a * a * a`.

#### `sugar.maths. pow (a, b)`
- Returns the result of `a` to the power of `b`.
- `pow(a, 2)` is **much slower** than `sqr(a)`.

&#8202;

#### `sugar.maths. sqrt (a)`
- Returns the square root of `a`.

&#8202;

#### `sugar.maths. abs (a)`
- Returns the absolute (positive) value of `a`.

&#8202;

#### `sugar.maths. min (a, b)`
- Returns the lower value between `a` and `b`.

&#8202;

#### `sugar.maths. max (a, b)`
- Returns the higher value between `a` and `b`.

&#8202;

#### `sugar.maths. mid (a, b, c)`
- Returns the middle value between `a`, `b` and `c`.
- `mid(1, 3, 2)` will return `2`.

&#8202;

#### `sugar.maths. angle_diff (a1, a2)`
- Returns the difference between the turn-based angle `a1` and the turn-based angle `a2`.

&#8202;

#### `sugar.maths. dist (x1, y1, [x2, y2])`
- If x2 and y2 are set, returns the distance between {x1; y1} and {x2; y2}.
- Otherwise, returns the distance between {0; 0} and {x1; y1}.

&#8202;

#### `sugar.maths. sqrdist (x, y)`
- Returns the squared distance between {0; 0} and {x1; y1}.
- Is faster than `dist(...)`.

&#8202;

---

#### `sugar.maths. srand (seed)`
- Sets the seed for the random number generation.

&#8202;

#### `sugar.maths. raw_rnd ()`
- Returns a random number.
- Always returns an integer.

&#8202;

#### `sugar.maths. rnd (n)`
- Returns a random decimal number between `0` *(included)* and `n` *(excluded)*.

&#8202;

#### `sugar.maths. irnd (n)`
- Returns a random integer number between `0` *(included)* and `n` *(excluded)*.

&#8202;

#### `sugar.maths. pick (tab)`
- Takes an ordered table *(with linear numeral keys)* as parameter.
- Returns a random element from the table.
