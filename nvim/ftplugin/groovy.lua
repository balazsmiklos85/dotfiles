local lspconfig = require('lspconfig')
lspconfig.groovyls.setup {
  cmd = {
    "java", "-jar", os.getenv("HOME") .. "/.local/bin/groovy-language-server/build/libs/groovy-language-server-all.jar"
  }
}

