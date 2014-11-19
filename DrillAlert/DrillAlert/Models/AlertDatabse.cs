using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace DrillAlert.Models
{
    public static class AlertDatabse
    {
        /// <summary>
        /// The connection string
        /// </summary>
        private static readonly string ConnectionStr = ConfigurationManager.AppSettings["AlertsDBConnectionString"];

        /// <summary>
        /// The connection
        /// </summary>
        private static readonly SqlConnection Connection = new SqlConnection(ConnectionStr);

        /// <summary>
        /// The sql data reader
        /// </summary>
        private static SqlDataReader reader;

        /// <summary>
        /// Gets the alert specified by an identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        public static Alert GetAlert(int id)
        {
            Connection.Open();
            var command = new SqlCommand("SELECT * FROM Alerts WHERE ID = " + id, Connection);
            reader = command.ExecuteReader();

            Alert alert = null;

            while (reader.Read())
            {
                alert = new Alert(
                    Convert.ToInt32(reader[0]),         //id
                    Convert.ToInt32(reader[1]),         //userId
                    reader[2].ToString(),               //parameter
                    bool.Parse(reader[3].ToString()),   //isGreaterThan
                    Convert.ToInt32(reader[4]));        //value
            }
            
            Connection.Close();

            return alert;
        }
    }
}