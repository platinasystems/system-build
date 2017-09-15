// Copyright © 2015-2017 Platina Systems, Inc. All rights reserved.
// Use of this source code is governed by the GPL-2 license described in the
// LICENSE file.

// mk-bmc-ver.go:  Make BMC Version Block

package main

import (
	"fmt"
	"os"
	"os/exec"
	"os/user"
	"strings"
	"time"
)

type RELINFO struct {
	Rel    [32]byte
	Date   [32]byte
	User   [32]byte
	Unused [256 - 3*32]byte
}
type IMGINFO struct {
	Name   [32]byte
	Build  [32]byte
	User   [16]byte
	Size   [16]byte
	GitTag [32]byte
	Commit [64]byte
	Chksum [64]byte
}
type IMAGE struct {
	Name string
	Dir  string
	File string
}

var RelInfo RELINFO
var ImgInfo [5]IMGINFO
var VerBlock [256 * 1024]byte

var Images = [5]IMAGE{
	{"ubo", "src/u-boot", "platina-mk1-bmc-ubo.bin"},
	{"dtb", "src/linux", "platina-mk1-bmc.dtb"},
	{"env", ".", "platina-mk1-bmc-env.bin"},
	{"ker", "src/linux", "platina-mk1-bmc.vmlinuz"},
	{"ini", "../go", "initrd.img.xz"},
}

func main() {
	initQSPIdata()
	getRelInfo() //TODO add arg for release
	for i, _ := range Images {
		getImageInfo(i, Images[i].Name, Images[i].Dir, Images[i].File)
	}
	writeVerFile()
}

func initQSPIdata() {
	for i, _ := range RelInfo.Rel {
		RelInfo.Rel[i] = 0xff
	}
	for i, _ := range RelInfo.Date {
		RelInfo.Date[i] = 0xff
	}
	for i, _ := range RelInfo.User {
		RelInfo.User[i] = 0xff
	}
	for i, _ := range RelInfo.Unused {
		RelInfo.Unused[i] = 0xff
	}
	for j, _ := range ImgInfo {
		for i, _ := range ImgInfo[j].Name {
			ImgInfo[j].Name[i] = 0xff
		}
		for i, _ := range ImgInfo[j].Build {
			ImgInfo[j].Build[i] = 0xff
		}
		for i, _ := range ImgInfo[j].User {
			ImgInfo[j].User[i] = 0xff
		}
		for i, _ := range ImgInfo[j].Size {
			ImgInfo[j].Size[i] = 0xff
		}
		for i, _ := range ImgInfo[j].GitTag {
			ImgInfo[j].GitTag[i] = 0xff
		}
		for i, _ := range ImgInfo[j].Commit {
			ImgInfo[j].Commit[i] = 0xff
		}
		for i, _ := range ImgInfo[j].Chksum {
			ImgInfo[j].Chksum[i] = 0xff
		}
	}
	for i, _ := range VerBlock {
		VerBlock[i] = 0xff
	}
}

func getRelInfo() {
	//TODO ADD NAME //DEV
	t := time.Now()
	fmt.Println("NOW: ", t.Format("2006-01-02 15:04:05"))
	user, _ := user.Current()
	fmt.Println("BY: ", user.Username)
}

func getImageInfo(x int, nm string, di string, im string) {
	u, err := exec.Command("ls", "-l", im).Output()
	if err != nil {
		fmt.Println("ERR1A")
		return
	}
	uu := strings.Split(string(u), " ")
	t := time.Now()
	yr := t.Format("2006")
	fmt.Println("platina-mk-bmc-" + nm + ".bin")              //name
	fmt.Println(uu[2])                                        //user
	fmt.Println(uu[5] + " " + uu[6] + " " + yr + " " + uu[7]) //date
	fmt.Println(uu[4])                                        //size

	{
		od, err := os.Getwd()
		if err != nil {
			fmt.Println("ERR0") //TODO et al
			return
		}
		err = os.Chdir(di)
		if err != nil {
			fmt.Println(err)
			return
		}
		defer os.Chdir(od)

		u, err = exec.Command("git", "tag").Output()
		if err != nil {
			fmt.Println("ERR2")
			return
		}
		uu = strings.Split(string(u), "\n")
		//TODO sort tags, find latest
		fmt.Println(uu[len(uu)-2]) //git tag

		u, err = exec.Command("git", "log", "-1").Output()
		if err != nil {
			fmt.Println("ERR2")
			return
		}
		uu = strings.Split(string(u), "\n")
		uuu := strings.Split(string(uu[0]), " ")
		fmt.Println(uuu[1]) //git commit

		err = os.Chdir(od)
	}

	u, err = exec.Command("sha1sum", im).Output()
	if err != nil {
		fmt.Println("ERR1")
		return
	}
	uu = strings.Split(string(u), "\n")
	uuu := strings.Split(string(uu[0]), " ")
	fmt.Println(uuu[0]) //checksum

	//TODO add data to block instead of printing
}

func writeVerFile() { //TODO
}
