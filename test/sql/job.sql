CREATE TABLE t (
 t timestamptz
);
WITH
 id AS
 (INSERT INTO pgagent.pga_job (jobjclid, jobname, jobdesc, jobenabled, jobhostagent)
  SELECT jcl.jclid, 'job1', '', true, ''
   FROM pgagent.pga_jobclass jcl WHERE jclname='Routine Maintenance'
  RETURNING jobid),
 insertstep AS
 (INSERT INTO pgagent.pga_jobstep (jstjobid, jstname, jstdesc, jstenabled, jstkind, jstonerror, jstcode, jstdbname, jstconnstr)
  SELECT id.jobid, 'step1', '', true, 's', 'f', 'INSERT INTO t VALUES (now())', 'contrib_regression', ''
   FROM id)
INSERT INTO pgagent.pga_schedule (jscjobid, jscname, jscdesc, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths, jscenabled, jscstart, jscend)
 SELECT id.jobid, 'schedule1', '', '{t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t}', '{t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t}', '{t,t,t,t,t,t,t}', '{t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,t}', '{t,t,t,t,t,t,t,t,t,t,t,t}', true, '2000-01-01 00:00:00', '2099-12-31 00:00:00'
  FROM id;
\! ( pgagent -f -l 2 -s pgagent.out "user=$PGUSER dbname=contrib_regression" ) & sleep 80; kill $! 2> /dev/null || :
SELECT count(*) > 0 AS job_run FROM t;
