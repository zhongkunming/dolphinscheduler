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

package org.apache.dolphinscheduler.plugin.task.addax;

import lombok.Data;
import org.apache.dolphinscheduler.common.utils.JSONUtils;
import org.apache.dolphinscheduler.plugin.task.api.enums.ResourceType;
import org.apache.dolphinscheduler.plugin.task.api.model.ResourceInfo;
import org.apache.dolphinscheduler.plugin.task.api.parameters.AbstractParameters;
import org.apache.dolphinscheduler.plugin.task.api.parameters.resource.DataSourceParameters;
import org.apache.dolphinscheduler.plugin.task.api.parameters.resource.ResourceParametersHelper;
import org.apache.dolphinscheduler.spi.enums.Flag;

import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.Objects;

/**
 * Addax parameter
 */
@Data
public class AddaxParameters extends AbstractParameters {

    /**
     * if custom json config，eg  0, 1
     */
    private int customConfig;

    /**
     * if customConfig eq 1 ,then json is usable
     */
    private String json;

    /**
     * data source type，eg  MYSQL, POSTGRES ...
     */
    private String dsType;

    /**
     * datasource id
     */
    private int dataSource;

    /**
     * data target type，eg  MYSQL, POSTGRES ...
     */
    private String dtType;

    /**
     * datatarget id
     */
    private int dataTarget;

    private String sql;

    private String targetTable;

    private List<String> preStatements;

    private List<String> postStatements;

    /**
     * speed byte num
     */
    private int jobSpeedByte;

    /**
     * speed record count
     */
    private int jobSpeedRecord;

    /**
     * datax channel
     */
    private int jobChannel;

    /**
     * Xms memory
     */
    private int xms;

    /**
     * Xmx memory
     */
    private int xmx;

    /**
     * writer batch size for DataX
     */
    private int batchSize;

    private List<ResourceInfo> resourceList;

    @Override
    public boolean checkParameters() {
        if (customConfig == Flag.NO.ordinal()) {
            return dataSource != 0
                    && dataTarget != 0
                    && StringUtils.isNotEmpty(sql)
                    && StringUtils.isNotEmpty(targetTable);
        } else {
            return StringUtils.isNotEmpty(json);
        }
    }

    @Override
    public List<ResourceInfo> getResourceFilesList() {
        return resourceList;
    }

    @Override
    public String toString() {
        return "AddaxParameters{" +
                "customConfig=" + customConfig +
                ", json='" + json + '\'' +
                ", dsType='" + dsType + '\'' +
                ", dataSource=" + dataSource +
                ", dtType='" + dtType + '\'' +
                ", dataTarget=" + dataTarget +
                ", sql='" + sql + '\'' +
                ", targetTable='" + targetTable + '\'' +
                ", preStatements=" + preStatements +
                ", postStatements=" + postStatements +
                ", jobSpeedByte=" + jobSpeedByte +
                ", jobSpeedRecord=" + jobSpeedRecord +
                ", jobChannel=" + jobChannel +
                ", xms=" + xms +
                ", xmx=" + xmx +
                ", batchSize=" + batchSize +
                ", resourceList=" + JSONUtils.toJsonString(resourceList) +
                '}';
    }

    @Override
    public ResourceParametersHelper getResources() {
        ResourceParametersHelper resources = super.getResources();

        if (customConfig == Flag.YES.ordinal()) {
            return resources;
        }
        resources.put(ResourceType.DATASOURCE, dataSource);
        resources.put(ResourceType.DATASOURCE, dataTarget);
        return resources;
    }

    public AddaxTaskExecutionContext generateExtendedContext(ResourceParametersHelper parametersHelper) {

        AddaxTaskExecutionContext addaxTaskExecutionContext = new AddaxTaskExecutionContext();

        if (customConfig == Flag.YES.ordinal()) {
            return addaxTaskExecutionContext;
        }

        DataSourceParameters dbSource =
                (DataSourceParameters) parametersHelper.getResourceParameters(ResourceType.DATASOURCE, dataSource);
        DataSourceParameters dbTarget =
                (DataSourceParameters) parametersHelper.getResourceParameters(ResourceType.DATASOURCE, dataTarget);

        if (Objects.nonNull(dbSource)) {
            addaxTaskExecutionContext.setDataSourceId(dataSource);
            addaxTaskExecutionContext.setSourcetype(dbSource.getType());
            addaxTaskExecutionContext.setSourceConnectionParams(dbSource.getConnectionParams());
        }

        if (Objects.nonNull(dbTarget)) {
            addaxTaskExecutionContext.setDataTargetId(dataTarget);
            addaxTaskExecutionContext.setTargetType(dbTarget.getType());
            addaxTaskExecutionContext.setTargetConnectionParams(dbTarget.getConnectionParams());
        }
        return addaxTaskExecutionContext;
    }
}
