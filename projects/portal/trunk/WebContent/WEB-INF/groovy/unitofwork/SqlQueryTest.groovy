package unitofwork
import groovy.io.FileType
import architecture.ee.services.support.UnitOfWorkForSqlQuery
import architecture.ee.jdbc.sqlquery.*;

class SqlQueryTest extends  UnitOfWorkForSqlQuery {
	
	def getTableNames(String tableName){		
	    println( "hello what the hell !!" );
		println( "getTableNames called with params : " + tableName  )
		return sqlQuery.list("BUSINESS.SELECT_TABLENAMES_LIKE_NAME", tableName)
	}
	
	def getTableData(String tableName){
		SqlQueryHelper helper = new SqlQueryHelper();
		helper.additionalParameter("TABLE_NAME", tableName);
		List<Map<String, Object>> list = helper.list( sqlQuery, "BUSINESS.SELECT_TABLE");
		return list;
	}

}
