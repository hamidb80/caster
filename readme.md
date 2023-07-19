# Caster
casting sugar for procedure parameters.

## Example
It is specially useful in event handling scenarios:
```nim
type
  Event = ref object of RootObj
  MouseEvent = ref object of Event
    mousex, mousey: int

elem.addEventListener proc(me: MouseEvent) = discard # error: Expected `Event` but got `MouseEvent`
elem.addEventListener proc(me: Event as MouseEvent) {.caster.} = # works!
  echo me.mousex
  # ...
```

## More
see [docs](https://hamidb80.github.io/caster) or `./tests/test.nim`.
