package storage

import (
	. "github.com/visualphoenix/gearmand/common"
)

type JobQueue interface {
	Init() error
	AddJob(j *Job) error
	DoneJob(j *Job) error
	GetJobs() ([]*Job, error)
}
