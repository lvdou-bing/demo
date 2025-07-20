import { ComponentContent, UIContext } from '@kit.ArkUI';

class Params {
  text: string = "";
  closeDialog?: () => void;
  constructor(text: string, closeDialog?: () => void) {
    this.text = text;
    this.closeDialog = closeDialog;
  }
}

@Builder
function buildDialog(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 20 })
    Row() {
      Button('确认')
        .onClick(() => {
          params.closeDialog && params.closeDialog();
        })
      Button('取消')
        .margin({ left: 20 })
        .onClick(() => {
          params.closeDialog && params.closeDialog();
        })
    }
  }.padding(20).backgroundColor('#FFF0F0F0')
}
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private ctx: UIContext = this.getUIContext();
  private closeTimer: number | undefined = undefined;
  private contentNode: ComponentContent<Object> | undefined = undefined;

  private closeDialog() {
    if (this.closeTimer !== undefined) {
      clearTimeout(this.closeTimer);
      this.closeTimer = undefined;
    }
    if (this.contentNode !== undefined) {
      this.ctx.getPromptAction().closeCustomDialog(this.contentNode)
        .then(() => {
          if (this.contentNode !== undefined) {
            this.contentNode.dispose();
          }
        })
    }
  }

  build() {
    RelativeContainer() {
      Button('弹出自定义弹框')
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.contentNode = new ComponentContent(this.ctx, wrapBuilder(buildDialog), new Params('这是一个自定义弹框', this.closeDialog.bind(this)));
          this.ctx.getPromptAction().openCustomDialog(this.contentNode, { alignment: DialogAlignment.Center })
            .then(() => {
              this.closeTimer = setTimeout(() => {
                this.closeDialog();
              }, 2000);
            })
        })
    }
    .height('100%')
    .width('100%')
  }
}
