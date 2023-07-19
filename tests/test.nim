import std/unittest
import caster


type
  Event = ref object of RootObj
  MouseEvent = ref object of Event
    mousePos: tuple[x, y: int]


suite "basic":
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

suite "advanced":
  test "multi args":
    proc p1(c: char as byte, a: char, p: int as pointer) {.caster.} =
      check c is byte
      check a is char
      check p is pointer

    p1 '1', '2', 3

  test "grouped params":
    proc p2(b1, b2: char as byte, c: char) {.caster.} =
      check b1 is byte
      check b2 is byte
      check c is char

    p2 '1', '2', '3'

  test "grouped params with default value":
    func toByteRepr(a,b,c: char as uint8 = '0'): string {.caster.} =
      $(a+b+c)

    check $(48*3) == toByteRepr()
