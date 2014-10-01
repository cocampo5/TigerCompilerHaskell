{
module EAFIT.DIS.MagnumOpusLexer(AlexPosn(..), alexScanTokens, token_posn) where
import Data.Char(toUpper)
}


%wrapper "posn"


$any		= .
$assign	 	= [\=]
$dosp		= [\:]
$mayor		= [\>]
$menor		= [\<]
$comilla	= [\"]
$nozero		= [1..9]
$digit 		= 0-9
$alpha		= [a-zA-Z]
@keywords 	= array | break | do | else | end | for | function | if | in | let | nil | of | then | to | type | var | while
@let		= [$dosp][$assign]
@dif		= [$menor][$mayor]
@mayorI		= [$mayor][$assign]
@menorI		= [$menor][$assign]
@operator 	= ([\( \) \[ \] \{ \} \: \. \, \; \* \/ \- \+ \= \> \< \& \|]|@let|@dif|@mayorI|@menorI)
@ident 		= $alpha($alpha | $digit | \_ )*
@LitInt  	= ($digit)+
@LitStr	= [$comilla]($printable | $white)+[$comilla]


tokens :-

  "//".*		; -- Ignore
  "/*"(. | [\r\n])*"*/" ; -- Ignore
  $white+		; -- Ignore
  @operator 		{tok( \p s -> Operator p s)}
  @keywords 		{tok( \p s -> Keyword p s)}
  @LitInt		{tok( \p s -> IntegerLiteral p (read s))}
  @LitStr		{tok( \p s -> StringLiteral p s)}
  @ident  		{tok( \p s -> Identifier p s)}
  $any			{tok( \(AlexPn _ l c) s -> error $ "Error en la linea " ++ (show l) ++ ", columna " ++ (show c) ++ ". ")}

{
tok f p s = f p s

data Token =
  Keyword          AlexPosn String |
  Separator        AlexPosn String |
  Operator         AlexPosn String |
  IntegerLiteral   AlexPosn    Int |
  StringLiteral    AlexPosn String |
  Identifier       AlexPosn String 
  deriving(Eq,Show)

token_posn (Keyword p _) = p
token_posn (Operator p _) = p
token_posn (Separator p _) = p
token_posn (IntegerLiteral p _) = p
token_posn (StringLiteral p _) = p
token_posn (Identifier p _) = p
}


