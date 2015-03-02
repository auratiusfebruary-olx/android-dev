 
// grant access to all users
function(doc) {
  channel("all_channels");
  if (doc.type == "salesperson") {
    var userID = doc.user_id;
    access(userID, "all_channels")
  }
  channel(doc.channels);
}


// final sync function

function(doc, oldDoc) {
  channel("all_docs");
  if (doc.type === "salesperson") {
    var userID = doc.user_id;
    //if user logged as admin we add him access to all_docs channel and role
    if (doc.isAdmin) {
      access(userID, "all_docs")
      role(userID, "role:admin")
    }
    if (oldDoc) {
      //salespeople can only be approved by admin. when we approve sales person we grant him access to all_docs channel
      if(doc.approved && !oldDoc.approved){
        access(userID, "all_docs")
        requireRole("admin")
      }
      else{
        //salespeople can only be edited by themselves
        requireUser(userID)  
      }
    }
    else{
      //salespeople can only be created by themselves
      requireUser(userID)
    }
  }
}

