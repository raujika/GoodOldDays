gcd       :: Int -> Int -> Int
gcd x y    = gcd' (abs x) (abs y)
             where gcd' x 0 = x
                   gcd' x y = gcd' y (x `rem` y)
