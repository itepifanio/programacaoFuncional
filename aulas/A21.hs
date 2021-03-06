{-
module Trees where

data Tree a = Leaf a | Node (Tree a) a (Tree a)
    deriving (Eq, Show)

flatten :: Tree a -> [a]
flatten (Leaf x)     = [x]
flatten (Node l x r) = flatten l ++ [x] ++ flatten r

tmap :: (a -> b) -> Tree a -> Tree b
tmap f (Leaf x)     = Leaf (f x)
tmap f (Node l x r) = Node (tmap f l) (f x) (tmap f r)
-}

module Maybe where

import Prelude hiding (Maybe(..), Either)
data Maybe a = Nothing | Just a
    deriving (Eq, Show)

data Either a b = Left a | Right b
 

bottom :: a
bottom = bottom

safeHead :: [a] -> Maybe a
safeHead []     = Nothing 
safeHead (x:_)  = Just x


