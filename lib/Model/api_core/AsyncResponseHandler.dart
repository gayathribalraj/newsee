/* 
@type         : class
@author       : karthick.d
@created      : 13/05/2025
@description  : AsyncResponseHandler class is a helper class for error handler in 
                async operation it's like resolve , reject super imposing generics for returning 
                type safe objects

 */
class AsyncResponseHandler<L, R> {
  final L? _left;
  final R? _right;

  /* 
@type         : private constructor  " class._() " 
@desc         : private constructor can be accessed only inside this class
                set value for instance variable left and right
 */
  AsyncResponseHandler._(this._left, this._right);

  /* 
@type         : factory constructor
@desc         : factory constructor set value for instance variable left and right
                by calling private constructor
 */

  factory AsyncResponseHandler.left(L left) =>
      AsyncResponseHandler._(left, null);

  factory AsyncResponseHandler.right(R right) =>
      AsyncResponseHandler._(null, right);

  // getter for left variable
  L get left =>
      this._left != null ? _left : throw StateError("called left on Right");

  R get right =>
      this._right != null ? _right : throw StateError("called right on Left");

  bool isLeft() => _left != null;

  bool isRight() => _right != null;
}
