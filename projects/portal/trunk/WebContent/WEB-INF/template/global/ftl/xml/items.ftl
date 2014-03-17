<?xml version="1.0" encoding="UTF-8"?>
<response>
<#if items?has_content >
  <totalItemSize>${items?size}</totalItemSize>
  <items>
<#list items as item>
    <item>
    <#list item?keys as key>
        <${key}>${item[key]}</${key}>
    </#list>
    </item>
</#list>
  </items>
 </#if> 
 <#if item?has_content >
   <totalItemSize>1</totalItemSize>
    <item>
    <#list item?keys as key>
        <${key}>${item[key]}</${key}>
    </#list>
    </item>   
 </#if> 
</response>