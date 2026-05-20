/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.dolphinscheduler.plugin.task.api;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.MapUtils;
import org.apache.dolphinscheduler.plugin.task.api.model.Property;

import java.util.Map;
import java.util.regex.Matcher;

@Slf4j
public abstract class AbstractSqlTask extends AbstractTask {

    /**
     * constructor
     *
     * @param taskExecutionContext taskExecutionContext
     */
    protected AbstractSqlTask(TaskExecutionContext taskExecutionContext) {
        super(taskExecutionContext);
    }

    /**
     * print replace sql
     *
     * @param formatSql    format sql
     * @param sqlParamsMap sql params map
     */
    public void printReplacedSql(String formatSql, Map<Integer, Property> sqlParamsMap) {
        // parameter print style
        log.info("after replace sql, preparing: {}", formatSql);
        if (MapUtils.isEmpty(sqlParamsMap)) {
            log.info("printReplacedSql: sqlParamsMap is null.");
            return;
        }
        StringBuilder logPrint = new StringBuilder("replaced sql, parameters:");
        for (int i = 1; i <= sqlParamsMap.size(); i++) {
            logPrint.append(sqlParamsMap.get(i).getValue())
                    .append("(")
                    .append(sqlParamsMap.get(i).getType())
                    .append(")");
        }
        log.info("sql params are {}", logPrint);
    }

    /**
     * regular expressions match the contents between two specified strings
     *
     * @param content        content
     * @param sqlParamsMap   sql params map
     * @param paramsPropsMap params props map
     */
    public void setSqlParamsMap(String content, Map<Integer, Property> sqlParamsMap,
                                Map<String, Property> paramsPropsMap, int taskInstanceId) {
        if (paramsPropsMap == null) {
            return;
        }

        Matcher matcher = TaskConstants.SQL_PARAMS_PATTERN_PARAM.matcher(content);
        int index = 1;
        while (matcher.find()) {
            String paramName = matcher.group(TaskConstants.GROUP_NAME1);
            Property prop = paramsPropsMap.get(paramName);
            if (prop == null) {
                log.error(
                        "setSqlParamsMap: No Property with paramName: {} is found in paramsPropsMap of task instance"
                                + " with id: {}. So couldn't put Property in sqlParamsMap.",
                        paramName, taskInstanceId);
            } else {
                sqlParamsMap.put(index, prop);
                index++;
                log.info(
                        "setSqlParamsMap: Property with paramName: {} put in sqlParamsMap of content {} successfully.",
                        paramName, content);
            }

        }
    }
}
