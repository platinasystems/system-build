package main

import (
	"io/ioutil"
)

func main() {
	a, err := ioutil.ReadFile("crc.ascii")
	if err != nil {
		panic(err)
	}

	b := []byte{0, 0, 0, 0}
	for k := 0; k < 8; k++ {
		if a[k] > 0x4f {
			a[k] = a[k] - 0x20
		}
		if a[k] > 0x39 {
			a[k] = a[k] - 7
		}
	}
	b[0] = ((a[6] - 0x30) * 0x10) + (a[7] - 0x30)
	b[1] = ((a[4] - 0x30) * 0x10) + (a[5] - 0x30)
	b[2] = ((a[2] - 0x30) * 0x10) + (a[3] - 0x30)
	b[3] = ((a[0] - 0x30) * 0x10) + (a[1] - 0x30)

	err = ioutil.WriteFile("crc", b, 0644)
	if err != nil {
		panic(err)
	}
}
