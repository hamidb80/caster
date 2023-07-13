import std/unittest
import caster


type
  Event = ref object of RootObj
  MouseEvent = ref object of Event
    mousePos: tuple[x, y: int]


test "char -> byte":
  func toByteRepr(b: char as byte): string {.caster.} =
    $b

  check "97" == toByteRepr 'a'


test "Inheritance":
  proc wrap(callback: proc(e: Event)) =
    callback Event MouseEvent(mousePos: (1, 2))

  var acc = 0

  wrap proc(me: Event as MouseEvent) {.caster.} =
    acc.inc me.mousePos.x
    acc.inc me.mousePos.y * 10

  check acc == 21
