package main

import (
	"flag"
	log "github.com/Sirupsen/logrus"
	gearmand "github.com/visualphoenix/gearmand/server"
	"github.com/visualphoenix/gearmand/storage/mysql"
	"github.com/visualphoenix/gearmand/storage/redisq"
	"github.com/visualphoenix/gearmand/storage/sqlite3"
	"runtime"
)

var (
	addr    = flag.String("addr", ":4730", "listening on, such as 0.0.0.0:4730")
	path    = flag.String("coredump", "./", "coredump file path")
	redis   = flag.String("redis", "localhost:6379", "redis address")
	verbose = flag.Bool("verbose", false, "Enables output of line numbers in the log.")
	//todo: read from config files
	mysqlSource   = flag.String("mysql", "user:password@tcp(localhost:3306)/gogearmand?parseTime=true", "mysql source")
	sqlite3Source = flag.String("sqlite3", "gearmand.db", "sqlite3 source")
	storage       = flag.String("storage", "sqlite3", "choose storage(redis or mysql, sqlite3)")
)

func main() {
	flag.Parse()
	gearmand.PublishCmdline()
	gearmand.RegisterCoreDump(*path)
	if *verbose {
		log.SetLevel(log.WarnLevel)
	}
	//log.SetHighlighting(false)
	runtime.GOMAXPROCS(1)
	if *storage == "redis" {
		gearmand.NewServer(&redisq.RedisQ{}).Start(*addr)
	} else if *storage == "mysql" {
		gearmand.NewServer(&mysql.MYSQLStorage{Source: *mysqlSource}).Start(*addr)
	} else if *storage == "sqlite3" {
		gearmand.NewServer(&sqlite3.SQLite3Storage{Source: *sqlite3Source}).Start(*addr)
	} else {
		log.Error("unknown storage", *storage)
	}
}
