#let mod(num) = {
  let res = (
    num.bit-and(0x3FF)
      + num.bit-rshift(10).bit-and(0x3FF)
      + num.bit-rshift(20).bit-and(0x3FF)
      + num.bit-rshift(30).bit-and(0x3FF)
      + num.bit-rshift(40).bit-and(0x3FF)
      + num.bit-rshift(50).bit-and(0x3FF)
      + num.bit-rshift(60)
  )
  res = res.bit-and(0x3FF) + res.bit-rshift(0x3FF)
  res = res.bit-and(0x3FF) + res.bit-rshift(0x3FF)
  while res >= 11 {
    res = res - 11
  }
  return res
}
