{-# LANGUAGE OverloadedStrings, ViewPatterns #-}
module Cauterize.Generators.Hs2010.Synchronous.Common
  ( sNameToTypeNameDoc
  , sNameToVarNameDoc
  , typeToTypeNameDoc
  , typeToVarNameDoc
  , hsFileName
  , biRepr
  , biReprText
  , nameToCapHsName

  , spacedBraces
  ) where

import Cauterize.Specification
import Cauterize.Common.Types

import qualified Data.Text.Lazy as T
import qualified Data.Char as C
import Text.PrettyPrint.Leijen.Text

hsFileName :: Spec -> FilePath
hsFileName s = let part = nameToCapHsName $ T.pack $ specName s :: T.Text
                   suff = ".hs"
               in T.unpack $ part `T.append` suff

nameToCapHsName :: T.Text -> T.Text
nameToCapHsName n = let terms = T.splitOn "_" n
                        cap (T.length -> 0) = ""
                        cap t = C.toUpper (T.head t) `T.cons` T.tail t
                    in T.concat $ map cap terms

nameToHsName :: T.Text -> T.Text
nameToHsName n = let (f:rest) = T.splitOn "_" n
                     cap (T.length -> 0) = ""
                     cap t = C.toUpper (T.head t) `T.cons` T.tail t
                 in T.concat $ f:map cap rest

sNameToTypeNameDoc :: String -> Doc
sNameToTypeNameDoc = text . nameToCapHsName . T.pack

sNameToVarNameDoc :: String -> Doc
sNameToVarNameDoc = text . nameToHsName . T.pack

typeToTypeNameDoc :: SpType -> Doc
typeToTypeNameDoc = sNameToTypeNameDoc . typeName

typeToVarNameDoc :: SpType -> Doc
typeToVarNameDoc = sNameToVarNameDoc . typeName

biRepr :: BuiltIn -> Doc
biRepr = text . biReprText

biReprText :: BuiltIn -> T.Text
biReprText BIu8 = "U8"
biReprText BIu16 = "U16"
biReprText BIu32 = "U32"
biReprText BIu64 = "U64"
biReprText BIs8 = "S8"
biReprText BIs16 = "S16"
biReprText BIs32 = "S32"
biReprText BIs64 = "S64"
biReprText BIieee754s = "Ieee754s"
biReprText BIieee754d = "Ieee754d"
biReprText BIbool = "Bool"

spacedBraces :: Doc -> Doc
spacedBraces p = braces $ " " <> p <> " "