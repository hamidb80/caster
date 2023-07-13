import std/macros
import macroplus

macro caster*(def): untyped =
  ## a sugar for casting parameters in the procedure body,
  ## It eliminates the need for manually casting.
  ##
  ## for an illustration, the 2 procedures are the same:

  runnableExamples:
    proc toNumericRepr1(c: char): string =
      let b = cast[byte](c)
      $b

    proc toNumericRepr2(b: char as byte): string {.caster.} =
      $b

    assert "97" == toNumericRepr1 'a'
    assert "97" == toNumericRepr2 'a'


  var before = newStmtList()
  result = def

  for i, p in def.params:
    if i != 0: # ignore return type
      let t = p[IdentDefType]
      if t.matchInfix "as":
        for id in p[IdentDefNames]:
          before.add newLetStmt(id, newTree(nnkCast, t[InfixRightSide], id))
          result.params[i][IdentDefType] = t[InfixLeftSide]

  result.body = newStmtList(before, result.body)
