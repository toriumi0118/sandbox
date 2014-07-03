package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
)

func isAlpha(c byte) bool {
	return c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z'
}

func splitter() bufio.SplitFunc {
	return func(data []byte, atEOF bool) (advance int, token []byte, err error) {
		var start int

		for start = 0; start < len(data); start++ {
			if isAlpha(data[start]) {
				break
			}
		}

		if atEOF && len(data) == 0 {
			return 0, nil, nil
		}

		for i := start; i < len(data); i++ {
			if !isAlpha(data[i]) {
				return i, data[start:i], nil
			}
		}

		if atEOF && len(data) > start {
			return len(data), data[start:], nil
		}

		return 0, nil, nil
	}
}

type wordcount struct {
	word string
	count int
}

type wclist []wordcount
func (p wclist) Len() int { return len(p) }
func (p wclist) Less(i, j int) bool { return p[i].count > p[j].count }
func (p wclist) Swap(i, j int) { p[i], p[j] = p[j], p[i] }

func toCountList(m map[string]int) wclist {
	ret := make(wclist, len(m))
	i := 0
	for k, v := range m {
		ret[i] = wordcount{k, v}
		i++
	}
	return ret
}

func main() {
	if len(os.Args) < 3 {
		fmt.Printf("Usage: %s [123] inputfile\n", os.Args[0])
		os.Exit(1)
	}

	var mode, e = strconv.Atoi(os.Args[1])
	if e != nil {
		fmt.Print(e, "\n")
		os.Exit(1)
	}
	var file = os.Args[2]

	fmt.Printf("mode=%d\n", mode)

	fp, e := os.Open(file)
	if e != nil {
		fmt.Print(e, "\n")
		os.Exit(1)
	}
	defer fp.Close()

	var s = bufio.NewScanner(fp)
	s.Split(splitter())

	result := make(map[string] int)
	for s.Scan() {
		t := s.Text()
		result[t] = result[t] + 1
	}

	rs := toCountList(result)
	sort.Sort(rs)
	for _, r := range rs {
		fmt.Printf("%s: %d\n", r.word, r.count)
	}
}
