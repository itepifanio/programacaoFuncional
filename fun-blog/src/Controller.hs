{-# LANGUAGE OverloadedStrings #-}
module Controller where

import Prelude hiding (id)
import Web.Scotty
import qualified Data.Text as T
import Models as M
import Data.Aeson hiding (json)
import Database.SQLite.Simple as Sql
import Control.Monad.IO.Class (liftIO)
import System.IO.Unsafe (unsafePerformIO)

instance ToJSON M.Post
instance FromJSON M.Post

instance Sql.FromRow M.Post where
    fromRow = M.Post <$> Sql.field  <*> Sql.field  <*> Sql.field

instance ToRow M.Post where
    toRow (M.Post tipo conteudo titulo) = toRow (tipo, conteudo, titulo)

-- Realiza consulta sql e traz os dados
allPosts :: Sql.Connection -> IO [M.Post]
allPosts conn = do
    Sql.query_ conn "select tipo, conteudo, titulo from posts" :: IO [M.Post]

-- Transforma uma lista de posts em json
jsonPosts :: [M.Post] -> ActionM ()
jsonPosts posts = json posts

-- Recebe o titulo, conteudo e tipo de post e cria um post
modelPost :: T.Text -> T.Text -> T.Text -> M.Post
modelPost t c tp =
    M.Post {
    titulo   = t,
    conteudo = c,
    tipo     = tp
    }

-- Insere post no banco de dados
insertPost :: ToRow b => b -> IO b
insertPost post = do
    conn <- Sql.open "db.sqlite3"
    Sql.execute conn "insert into posts (tipo, titulo, conteudo) values (?,?,?)" (post)
    return post

mkPost :: T.Text -> T.Text -> T.Text -> Maybe M.Post
mkPost titulo conteudo tipo
    | T.null titulo   == False = Nothing
    | T.null conteudo == False = Nothing
    | T.null tipo     == False = Nothing
    | otherwise = Just (modelPost titulo conteudo tipo)
{-
mkPost :: T.Text -> T.Text -> T.Text -> Either T.Text M.Post
mkPost titulo conteudo tipo
    | T.null titulo   == False = Left (T.pack "Nenhum titulo adicionado ao post")
    | T.null conteudo == False = Left (T.pack "Nenhum conteudo adicionado ao post")
    | T.null tipo     == False = Left (T.pack "Nenhum tipo foi adicionado ao post")
    | otherwise = Right $ modelPost titulo conteudo tipo
-}
