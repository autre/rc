
NAME := $(proj)
REQUIRE_JS_VERSION := 2.1.20
REQUIRE_JS_URL := 'http://requirejs.org/docs/release/$(REQUIRE_JS_VERSION)/minified/require.js'
REACT_JS_VERSION := 0.13.3
REACT_JS_URL := 'https://fb.me/react-$(REACT_JS_VERSION).min.js'
NORMALIZE_CSS_VERSION := 3.0.2
NORMALIZE_CSS_URL_VERSION := https://necolas.github.io/normalize.css/$(NORMALIZE_CSS_VERSION)/normalize.css
QUNIT_VERSION := 1.18.0
QUNIT_JS_URL := 'http://code.jquery.com/qunit/qunit-$(QUNIT_VERSION).js'
QUNIT_CSS_URL := 'http://code.jquery.com/qunit/qunit-$(QUNIT_VERSION).css'

INDEX =\
<!doctype html>\n\
<html>\n\
  <head lang="el">\n\
    <meta charset="utf-8">\n\
    <title>$(NAME)</title>\n\
    <meta name="viewport" content="width=device-width, initial-scale=1">\n\
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">\n\
\n\
    <link href="normalize.css" rel="stylesheet">\n\
    <link href="style.css" rel="stylesheet">\n\
    <script async data-main="src/boot" src="lib/require-$(REQUIRE_JS_VERSION)-min.js"></script>\n\
  </head>\n\
  <body>\n\
\n\
    <header>\n\
      <h2><div id="title">$(NAME)</div></h2>\n\
    </header>\n\
\n\
    <main>\n\
    </main>\n\
\n\
    <footer>\n\
      $$(date +'%B') 2015\n\
    </footer>\n\
\n\
  </body>\n\
</html>

BOOT =\
/* global requirejs */\n\
\n\
(function() {\n\
    \"use strict\";\n\
\n\
    requirejs.config({\n\
        baseUrl: 'src',\n\
        paths: {\n\
            'React': '../lib/react-$(REACT_JS_VERSION)-min',\n\
        },\n\
    });\n\
\n\
    requirejs(['app', 'React'], function(App, React) {\n\
        var main = document.getElementsByTagName('main')[0];\n\
        var HelloWorldView = React.createClass({\n\
            displayName: 'HelloWorldView',\n\
            render: function() {\n\
                return React.DOM.div(null, this.props.app.say_hi());\n\
            }\n\
        });\n\
\n\
	var app = new App();\n\
	var hello_view = React.createElement(HelloWorldView, { app: app });\n\
\n\
        React.render(hello_view, main);\n\
    });\n\
})();

APP =\
/* global define */\n\
\n\
define([], function() {\n\
    'use strict';\n\
\n\
    function App() {\n\
    }\n\
\n\
    App.prototype.say_hi = function() {\n\
        return 'ohai world';\n\
    };\n\
\n\
    return App;\n\
});

TEST_INDEX = \
<!doctype html>\n\
<html>\n\
  <head>\n\
    <meta charset="utf-8">\n\
    <title>tests for: $(NAME)</title>\n\
    <link rel="stylesheet" href="qunit-$(QUNIT_VERSION).css">\n\
  </head>\n\
  <body>\n\
    <div id="qunit"></div>\n\
    <div id="qunit-fixture"></div>\n\
    <script data-main="boot.js" src="../lib/require-$(REQUIRE_JS_VERSION)-min.js"></script>\n\
  </body>\n\
</html>

TEST_BOOT =\
/* global requirejs, QUnit */\n\
\n\
(function() {\n\
    'use strict';\n\
\n\
    requirejs.config({\n\
        paths: {\n\
            'QUnit': '../lib/qunit-1.18.0',\n\
            'app': '../src/app',\n\
        },\n\
        shim: {\n\
            'QUnit': {\n\
                exports: 'QUnit',\n\
                init: function() {\n\
                    QUnit.config.autoload = false;\n\
                    QUnit.config.autostart = false;\n\
                }\n\
            }\n\
        }\n\
    });\n\
\n\
    requirejs(['QUnit', 'test-app'], function(QUnit, test_app) {\n\
        QUnit.load();\n\
        QUnit.start();\n\
\n\
        test_app();\n\
    });\n\
})();

TEST_APP =\
/* global define */\n\
\n\
define(['QUnit', 'app'], function(QUnit, App) {\n\
    'use strict';\n\
\n\
    var test = QUnit.test,\n\
        assert = QUnit.assert,\n\
        module = QUnit.module;\n\
\n\
    return function() {\n\
        module('app', {\n\
            beforeEach: function() {\n\
                this.app = new App();\n\
            }\n\
        });\n\
\n\
        test('should say hi', function() {\n\
            assert.strictEqual(this.app.say_hi(), 'ohai world');\n\
        });\n\
    };\n\
});

new: make_dirs get_deps make_files notify_done

make_dirs:
	mkdir -p $(NAME)
	mkdir -p $(NAME)/{src,lib,test}

get_deps: get_require get_react get_normalize get_qunit

get_require:
	test ! -f $(NAME)/lib/require-$(REQUIRE_JS_VERSION)-min.js && curl -L -k -s $(REQUIRE_JS_URL) -o '$(NAME)/lib/require-$(REQUIRE_JS_VERSION)-min.js' || exit 0

get_react:
	test ! -f $(NAME)/lib/react-$(REACT_JS_VERSION)-min.js && curl -L -k -s $(REACT_JS_URL) -o '$(NAME)/lib/react-$(REACT_JS_VERSION)-min.js' || exit 0

get_normalize:
	test ! -f $(NAME)/normalize.css && curl -L -k -s $(NORMALIZE_CSS_URL_VERSION) -o '$(NAME)/normalize.css' || exit 0

get_qunit:
	test ! -f $(NAME)/test/qunit-$(QUNIT_VERSION).css && curl -L -k -s $(QUNIT_CSS_URL) -o '$(NAME)/test/qunit-$(QUNIT_VERSION).css' || exit 0
	test ! -f $(NAME)/lib/qunit-$(QUNIT_VERSION).js && curl -L -k -s $(QUNIT_JS_URL) -o '$(NAME)/lib/qunit-$(QUNIT_VERSION).js' || exit 0

make_files:
	@echo "$(INDEX)" >$(NAME)/index.html
	@touch $(NAME)/style.css
	@echo "$(BOOT)" >$(NAME)/src/boot.js
	@echo "$(APP)" >$(NAME)/src/app.js
	@echo "$(TEST_INDEX)" >$(NAME)/test/index.html
	@echo "$(TEST_BOOT)" >$(NAME)/test/boot.js
	@echo "$(TEST_APP)" >$(NAME)/test/test-app.js

notify_done:
	@echo you can know start the server with
	@echo "cd $(NAME) && nohup live-server 2>&1 >/dev/null &"
clean:
	rm -fr $(NAME)
