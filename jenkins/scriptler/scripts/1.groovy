import hudson.model.*
jenkins = Hudson.instance

println("Looking for slaves with labels: ${KEYWORDS}");
println("The matched host will be returned as: ${RETURNED_ENV_VARIALBE}");

keywordArray = KEYWORDS.split();
def matchedHost = null;
int i = 0;

for (aSlave in jenkins.slaves) {
  
  if (aSlave.labelString.contains(keywordArray[0])) {
    
    for (i=1; i<keywordArray.length ;i++) {
      if (!aSlave.labelString.contains(keywordArray[i])) {
          break;
      }
    }
    
    if (i==keywordArray.length) {
      matchedHost = aSlave
    }    
  }
  
}

if (matchedHost) {
  def pa = new ParametersAction([new StringParameterValue("${RETURNED_ENV_VARIALBE}", "${matchedHost.name}")])

  // add variable to current job
  Thread.currentThread().executable.addAction(pa)  
  
} else {
  println("No matches found!");
}

