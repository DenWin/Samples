import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import org.jenkinsci.plugins.plaincredentials.StringCredentials
import org.jenkinsci.plugins.plaincredentials.impl.FileCredentialsImpl
 
def seperator = { println ( " ".padLeft(20) + "--------------------------------------------------------------------------------------" ) }
 
def newLine = { println( "\n" ) }
 
def showHeader = {
    username,
    password ->
        newLine()
        seperator()
        println( "CredentialType : ".padLeft(20) + "ID".padRight(38) + " | "
                + username?.padRight(20) + " | "
                + password?.padRight(40) + " | "
                + "Description" )
}
 
def showRow = {
    credentialType,
    secretId,
    username = null,
    password = null,
    description = null ->
        println( "${credentialType} : ".padLeft(20) + secretId?.padRight(38) + " | "
                + username?.padRight(20) + " | "
                + password?.padRight(40) + " | "
                + description )
}
 
// set Credentials domain name (null means is it global)
domainName = null
 
credentialsStore = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0]?.getStore()
domain = new Domain(domainName, null, Collections.<DomainSpecification>emptyList())
 
showHeader( "UserName", "Password" )
credentialsStore?.getCredentials(domain).each {
  if( it instanceof UsernamePasswordCredentialsImpl )
  showRow( "user/password", it.id, it.username, it.password?.getPlainText(), it.description )
}
 
showHeader( "Passphrase", "PrivateKey" )
credentialsStore?.getCredentials(domain).each {
  if( it instanceof BasicSSHUserPrivateKey )
  showRow( "ssh priv key", it.id, it.passphrase?.getPlainText(), it.privateKeySource?.getPrivateKey()?.getPlainText(), it.description )
}
 
showHeader( "Secret", "" )
credentialsStore?.getCredentials(domain).each {
  if( it instanceof StringCredentials )
  showRow( "secret text", it.id, it.secret?.getPlainText(), '', it.description )
}
 
showHeader( "Content", "" )
credentialsStore?.getCredentials(domain).each {
  if( it instanceof FileCredentialsImpl )
  showRow( "secret file", it.id, it.content?.text, '', it.description )
}
 
showHeader( "", "" )
credentialsStore?.getCredentials(domain).each {
  if( !( it instanceof UsernamePasswordCredentialsImpl || it instanceof BasicSSHUserPrivateKey || it instanceof StringCredentials || it instanceof FileCredentialsImpl ) )
  showRow( "something else", it.id, '', '', '' )
}
 
return
