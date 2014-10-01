module EAFIT.DIS.MTigerCompiler(processFiles) where

import EAFIT.DIS.MagnumOpusLexer(alexScanTokens)
import System.Environment(getArgs)
import System.IO(stderr,hPutStrLn)

usage :: IO ()
usage = hPutStrLn stderr "Uso: Archivo .tiger"

processFile :: String -> IO ()
processFile file = do
  content <- readFile file
  print (alexScanTokens content)

processFiles :: IO ()
processFiles = do
  args <- getArgs
  if null args
   then
       usage
   else
       mapM_ processFile args

