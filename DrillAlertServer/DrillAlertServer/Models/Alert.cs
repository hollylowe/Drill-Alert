using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DrillAlertServer.Models
{
    /// <summary>
    /// Represents an alert setup by a user
    /// </summary>
    [Serializable]
    public class Alert
    {
        /// <summary>
        /// The identifier
        /// </summary>
        internal int Id;

        /// <summary>
        /// The user identifier
        /// </summary>
        internal int UserId;

        /// <summary>
        /// The parameter
        /// </summary>
        internal string Parameter;

        /// <summary>
        /// The is greater than
        /// </summary>
        internal bool IsGreaterThan;

        /// <summary>
        /// The value
        /// </summary>
        internal int Value;

        /// <summary>
        /// Initializes a new instance of the <see cref="Alert"/> class.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <param name="userId">The user identifier.</param>
        /// <param name="parameter">The parameter.</param>
        /// <param name="isGreaterThan">if set to <c>true</c> [is greater than].</param>
        /// <param name="value">The value.</param>
        public Alert(int id, int userId, string parameter, bool isGreaterThan, int value)
        {
            this.Id = id;
            this.UserId = userId;
            this.Parameter = parameter;
            this.IsGreaterThan = isGreaterThan;
            this.Value = value;
        }
    }
}