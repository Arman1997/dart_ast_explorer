import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String exampleCode = r"""
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show mergeMaps;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Horizontal Growth Example'),
          ),
          body: const AstWidget(
            code: exampleCode,
          )),
    );
  }
}

class AstWidget extends StatelessWidget {
  const AstWidget({super.key, required String code}) : _code = code;

  final String _code;

  @override
  Widget build(BuildContext context) {
    final builder = AstNodeDescriptorBuilder();
    parseString(content: _code).unit.accept(builder);

    return Container(
      color: const Color(0xfffdfdff),
      child: SingleChildScrollView(
        child: ASTNodeWidget(descriptor: builder.descriptor),
      ),
    );
  }
}

class AnotherAstWidget extends StatelessWidget {
  const AnotherAstWidget({super.key, required String code}) : _code = code;

  final String _code;

  @override
  Widget build(BuildContext context) {
    final builder = AstNodeDescriptorBuilder();
    parseString(content: _code).unit.accept(builder);

    return Container(
      color: const Color(0xfffdfdff),
      child: SingleChildScrollView(
        child: ASTNodeWidget(descriptor: builder.descriptor),
      ),
    );
  }
}

""";


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
          body: ChangeNotifierProvider(
            create: (context) => SourceCodeHighlighter(), 
            child: const MainPage(),
          )
        ),
    );
  }
}


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
      return  Row(
          children: [
           SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 36, 8),
                  child: Consumer<SourceCodeHighlighter>(
                    builder: (context, value, child) {
                      final position = value.position;
                      if (position != null) {
                        final preSelectionSubCode = exampleCode.substring(0, position.start);
                        final postSelectionSubCode = exampleCode.substring(position.end, exampleCode.length);
                        final selectionCode = exampleCode.substring(position.start, position.end);

                        return RichText(
                          text: TextSpan(
                            text: preSelectionSubCode,
                            style: const TextStyle(fontFamily: 'Sono', backgroundColor: Colors.transparent, color: Colors.black),
                            children: [
                              TextSpan(text: selectionCode, style: const TextStyle(backgroundColor: Colors.yellow, fontFamily: 'Sono')),
                              TextSpan(text: postSelectionSubCode, style: const TextStyle(fontFamily: 'Sono', backgroundColor: Colors.transparent, color: Colors.black))
                            ]
                            )
                          );
                      } 

                      return RichText(
                        text: const TextSpan(text: exampleCode, style: TextStyle(fontFamily: 'Sono', backgroundColor: Colors.transparent, color: Colors.black)),
                      );
                    },
                    child: const Text(
                      exampleCode,
                      style: TextStyle(fontFamily: 'Sono'),
                    ),
                  ))),
              SizedBox(
                width: 24.0,
                child: Container(
                  color: Colors.blueGrey,
                ),
              ),
              const Expanded(child: Align(alignment: Alignment.topLeft, child: AstWidget(code: exampleCode))),
          ],
        );
  }

}

class AstWidget extends StatelessWidget {
  const AstWidget({super.key, required String code}) : _code = code;

  final String _code;

  @override
  Widget build(BuildContext context) {
    final builder = AstNodeDescriptorBuilder();
    parseString(content: _code).unit.accept(builder);

    return Container(
      color: const Color(0xfffdfdff),
      child: SingleChildScrollView(
        child: ASTNodeWidget(descriptor: builder.descriptor),
      ),
    );
  }
}

final class AstNodeSourcePosition {
  final int start;
  final int end;

  const AstNodeSourcePosition({ required this.start, required this.end });

  factory AstNodeSourcePosition.fromSyntaxNode(SyntacticEntity entity) {
    return AstNodeSourcePosition(start: entity.offset, end: entity.end);
  }
}

final class ASTNodeDescriptor {
  final String runtimeTypeName;
  final TextStyle style;
  final List<ASTNodeDescriptor> children;
  final AstNodeSourcePosition sourcePosition;

  const ASTNodeDescriptor({
    required this.runtimeTypeName,
    required this.style,
    required this.children,
    required this.sourcePosition,
  });

  factory ASTNodeDescriptor.leaf({
    required String runtimeTypeName, 
    required TextStyle style,
    required AstNodeSourcePosition sourcePosition,
  }) => ASTNodeDescriptor(
      runtimeTypeName: runtimeTypeName,
      style: style,
      children: List.empty(),
      sourcePosition: sourcePosition,
    );
}

final class TokenStyle {
  static const _keywords = {
    "abstract",
    "else",
    "import",
    "show",
    "as",
    "enum",
    "in",
    "static",
    "assert",
    "export",
    "interface",
    "super",
    "async",
    "extends",
    "is",
    "switch",
    "await",
    "extension",
    "late",
    "sync",
    "base",
    "external",
    "library",
    "this",
    "break",
    "factory",
    "mixin",
    "throw",
    "case",
    "false",
    "new",
    "true",
    "catch",
    "final",
    "(variable)",
    "null",
    "try",
    "class",
    "(class)",
    "on",
    "typedef",
    "const",
    "finally",
    "operator",
    "var",
    "continue",
    "for",
    "part",
    "void",
    "covariant",
    "Function",
    "required",
    "when",
    "default",
    "get",
    "rethrow",
    "while",
    "deferred",
    "hide",
    "return",
    "with",
    "do",
    "if",
    "sealed",
    "yield",
    "dynamic",
    "implements",
    "set",
  };

  static const _operators = {
    "++",
    "--",
    "?.",
    "!",
    "-",
    "~",
    "await",
    "*",
    "/",
    "%",
    "~/",
    "<<",
    ">>",
    ">>>",
    "&",
    "^",
    "|",
    ">=",
    ">",
    "<=",
    "<",
    "as",
    "is",
    "is!",
    "==",
    "!=",
    "&&",
    "||",
    "??",
    ":",
    "..",
    "?..",
    "=",
    "(",
    ")",
    "[",
    "]",
    "{",
    "}",
    ".",
  };

  static const _specialCharacters = {
    ";",
    " ",
  };

  static const _defaultColor = Color(0xff02040f);
  static const _defaultFontSize = 14.0;

  final String token;

  const TokenStyle({required this.token});

  Color get _color {
    return  _specialCharacters.contains(token)
            ? const Color(0xffd90429)
            : _defaultColor;
  }

  double? get _fontSize {
    return _specialCharacters.contains(token)
        ? 14.0
        : _operators.contains(token) ||_keywords.contains(token)
            ? 12.0
                : _defaultFontSize;
  }

  FontWeight get _fontWeight =>
      _operators.contains(token) ? FontWeight.w600 : FontWeight.w500;

  TextStyle get style {
    return TextStyle(
      color: _color,
      fontSize: _fontSize,
      fontWeight: _fontWeight,
      fontFamily: 'Sono'
    );
  }
}

class ASTNodeWidget extends StatelessWidget {
  const ASTNodeWidget({
    super.key,
    required this.descriptor,
  });

  final ASTNodeDescriptor descriptor;

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
        title: Text(
          descriptor.runtimeTypeName,
          style: descriptor.style,
        ),
        content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: descriptor.children.map((e) {
                if (e.children.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 2.0, 16.0, 0.0),
                    child: ASTLeafWidget(descriptor: e),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 2.0, 16.0, 0.0),
                    child: ASTNodeWidget(descriptor: e),
                  );
                }
              }).map(
                (e) => Flexible(child: e)
              ).toList()), 
              onMouseEnter: () { 
                Provider.of<SourceCodeHighlighter>(context, listen: false).setHighlightedNodePosition(descriptor.sourcePosition);
              },
              onMouseExit: () {
                Provider.of<SourceCodeHighlighter>(context, listen: false).setHighlightedNodePosition(null);
              },
        );
  }
}

class ASTLeafWidget extends StatefulWidget {
  const ASTLeafWidget({super.key, required this.descriptor});

  final ASTNodeDescriptor descriptor;

  @override
  State<ASTLeafWidget> createState() => _ASTLeafWidgetState();
}

class _ASTLeafWidgetState extends State<ASTLeafWidget> {
  bool _highlighted = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: ((event) => _onMouseEnter(event, context)),
      onExit: ((event) => _onMouseExit(event, context)),
      child: Row(
        children: [
          const Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Icon(Icons.arrow_drop_down_rounded)),
          Container(
            color: _highlighted ? Colors.blue.shade100 : null,
            child: Text(
              widget.descriptor.runtimeTypeName,
              style: widget.descriptor.style,
            ),
          ),
        ],
      ),
    );
  }

  void _onMouseEnter(PointerEvent event, BuildContext context) {
    Provider.of<SourceCodeHighlighter>(context, listen: false).setHighlightedNodePosition(widget.descriptor.sourcePosition);
    setState(() {
      _highlighted = true;
    });
  }

  void _onMouseExit(PointerEvent event, BuildContext context) {
    Provider.of<SourceCodeHighlighter>(context, listen: false).setHighlightedNodePosition(null);
    setState(() {
      _highlighted = false;
    });
  }
}

class ExpandableSection extends StatefulWidget {
  const ExpandableSection(
      {super.key, required this.title, required this.content, required this.onMouseEnter, required this.onMouseExit});

  final Widget title;
  final Widget content;
  final VoidCallback onMouseEnter;
  final VoidCallback onMouseExit;

  @override
  State<StatefulWidget> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool _expanded = true;
  bool _highlighted = false;
  Widget _expandedIcon =
      const Icon(Icons.arrow_drop_down_rounded, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _highlighted ? Colors.blue.shade100 : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _expandedIcon,
              ),
              MouseRegion(
                onEnter: _onPointerEnter,
                onExit: _onPointerExit,
                child: widget.title,
              )
              ],
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
                if (_expanded) {
                  _expandedIcon = const Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.grey,
                  );
                } else {
                  _expandedIcon =
                      const Icon(Icons.arrow_drop_up_rounded, color: Colors.grey);
                }
              });
            },
        ),
        Visibility(
          visible: _expanded,
          maintainAnimation: true,
          maintainState: true,
          child: widget.content,
        )
      ]),
    );
  }

  void _onPointerEnter(PointerEvent event) {
    widget.onMouseEnter();
    setState(() {
      _highlighted = true;
    });
  }

  void _onPointerExit(PointerEvent event) {
    widget.onMouseExit();
    setState(() {
      _highlighted = false;
    });
  }
}

class AstNodeDescriptorBuilder extends GeneralizingAstVisitor {
  late ASTNodeDescriptor _descriptor;

  ASTNodeDescriptor get descriptor => _descriptor;

  @override
  visitNode(AstNode node) {
    _buildDescriptorWith(node: node);
  }

  @override
  visitCompilationUnit(CompilationUnit node) {
    _buildDescriptorWith(node: node, style: const TextStyle(color: Color(0xffd90429)));
  }

  static const _declarationStyle = TextStyle(
    color: Color.fromRGBO(0, 64, 221, 1.0),
  );

  @override
  visitDeclaration(Declaration node) {
    _buildDescriptorWith(node: node, style: _declarationStyle);
  }

  static const _expressionStyle = TextStyle(
    color: Color(0xff721cb8),
  );

  @override
  visitExpression(Expression node) {
    _buildDescriptorWith(
        node: node, style: _expressionStyle);
  }

  static const _identifierStyle = TextStyle(
    color: Color(0xffe59500),
  );

  @override
  visitIdentifier(Identifier node) {
    _buildDescriptorWith(node: node, style: _identifierStyle);
  }

  static const _commentStyle = TextStyle(
    color: Color(0xff3f7d20),
  );

  @override
  visitComment(Comment node) {
    _buildDescriptorWith(node: node, style: _commentStyle);
  }

  static const _namedTypeStyle = TextStyle(
    color: Color(0xff840032),
  );

  @override
  visitNamedType(NamedType node) {
    _buildDescriptorWith(node: node, style: _namedTypeStyle);
  }

  static const _defaultNodeStyle = TextStyle(
    color: Colors.black,
  );

  void _buildDescriptorWith({
    TextStyle style = _defaultNodeStyle,
    required AstNode node,
    }) {
    _descriptor = ASTNodeDescriptor(
      runtimeTypeName: _formatedRuntimeTypeName(node.runtimeType.toString()),
      style: style.copyWith(fontFamily: 'Sono'),
      children: _descriptorsFrom(node.childEntities),
      sourcePosition: AstNodeSourcePosition.fromSyntaxNode(node),
    );
  }

  List<ASTNodeDescriptor> _descriptorsFrom(
      Iterable<SyntacticEntity> childEntities) {
    return childEntities.map((node) {
      if (node is Token) {
        final name = _formatedRuntimeTypeName(node.toString());
        final style = TokenStyle(token: name).style;
        return ASTNodeDescriptor.leaf(
          runtimeTypeName: name, 
          style: style,
          sourcePosition: AstNodeSourcePosition.fromSyntaxNode(node),
        );
      } else if (node is AstNode) {
        node.accept(this);
        return _descriptor;
      }

      throw ("Unsuported entity type ${node.toString()}");
    }).toList();
  }

  String _formatedRuntimeTypeName(String runtimeTypeName) {
    if (runtimeTypeName.endsWith("Impl")) {
      return runtimeTypeName.substring(0, runtimeTypeName.length - 4);
    }

    return runtimeTypeName;
  }
}

class SourceCodeHighlighter extends ChangeNotifier {
  AstNodeSourcePosition? _position;

  AstNodeSourcePosition? get position => _position;

  void setHighlightedNodePosition(AstNodeSourcePosition? position) {
    _position = position;
    notifyListeners();
  }
}