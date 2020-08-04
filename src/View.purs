module View (View, ofView, emptyView, cmapView, pureView, runView) where

import Prelude

import Components (emptyHtml)
import Reader (Reader(..))
import Render (DocumentFragment)

-- NOTES (or what I've learned)
-- A type signature of "newtype View s a = View (s -> a)" makes our current methods function exactly as a reader
-- However, the cmap instance method cannot be defined as it wants to change the type of the right hand varible "a", not "s"
-- Using the type signature "newtype View s = View (s -> DocumentFragment)" doesn't seem to allow map or bind to be defined
--   since we do NOT wanted to change the type of "s" in either operation
-- Therefore, View can be defined using a Reader as "type View s = Reader s DocumentFragment"
-- View can then define a cmap method (but it appears types cannot have instance methods)  

type View s = Reader s DocumentFragment

cmapView :: forall s1 s2. (s2 -> s1) -> View s1 -> View s2
cmapView adapterFn (Reader render) = Reader \state -> render $ adapterFn state

emptyView :: forall s. View s
emptyView = pure emptyHtml

ofView :: forall s. DocumentFragment -> View s
ofView df = Reader \state -> df

runView :: forall s. View s -> s -> DocumentFragment
runView (Reader renderFn) state = renderFn state 

pureView :: forall s. (s -> DocumentFragment) -> View s
pureView f = Reader f
