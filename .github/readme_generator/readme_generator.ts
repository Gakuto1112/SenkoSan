import fs from "fs";
import readline from "readline";

class ReadmeGenerator {
    /**
     * 対象のレポジトリの名前
     */
    private readonly REPOSITORY_NAME: string;

    /**
     * テンプレートレポジトリの名前
     */
    private readonly TEMPLATE_REPOSITORY_NAME: string;

    /**
     * 対象のブランチの名前
     */
    private readonly TEMPLATE_BRANCH_NAME: string;


    /**
     * fetchして入手したマークダウンのキャッシュ
     */
    private readonly caches: {[key: string]: string} = {};

    /**
     * コンストラクタ
     */
    constructor(repositoryName: string, templateRepositoryName: string, templateBranchName: string) {
        this.REPOSITORY_NAME = repositoryName;
        this.TEMPLATE_REPOSITORY_NAME = templateRepositoryName;
        this.TEMPLATE_BRANCH_NAME = templateBranchName;
    }

    /**
     * READMEをテンプレートから生成する。
     * @param inputPath 入力するテンプレートのパス
     * @param outputPath 生成するREADMEの出力先のパス
     */
    public async generateReadme(inputPath: string, outputPath: string): Promise<void> {
        const writeStream: fs.WriteStream = fs.createWriteStream(outputPath, {encoding: "utf-8"});
        for await (let line of readline.createInterface({input: fs.createReadStream(inputPath, {encoding: "utf-8"}), output: writeStream})) {
            //画像のソースファイルの置き換え
            line = line.replace(/\.\.\/README_images\//g, "./README_images/");

            //テンプレートを挿入
            const injectTags: IterableIterator<RegExpMatchArray> = line.matchAll(/<!-- \$inject\(([^\\\/:*?"><|]+)\) -->/g);
            let charCount: number = 0;
            for(const injectTag of injectTags) {
                writeStream.write(line.substring(charCount, injectTag.index));
                charCount += (injectTag.index as number) + injectTag[0].length;
                const fileName: string = (inputPath.match(/([^\\\/:*?"><|]+)\.md/) as RegExpMatchArray)[1];
                if(this.caches[`${injectTag[1]}_${fileName}`] != undefined) writeStream.write(this.caches[`${injectTag[1]}_${fileName}`]);
                else {
                    const result: Response = await fetch(`https://raw.githubusercontent.com/${this.TEMPLATE_REPOSITORY_NAME}/${this.TEMPLATE_BRANCH_NAME}/templates/${injectTag[1]}/${fileName}.md`);
                    if(result.ok) {
                        console.info(`Fetched a resource. ${result.status} - ${result.statusText}`);
                        let text: string = await result.text();
                        if(injectTag[1] == "notes") {
                            //プレースホルダの置き換え
                            text = text.replace("<!-- $REPOSITORY_NAME -->", this.REPOSITORY_NAME);
                        }
                        writeStream.write(text);
                        this.caches[`${injectTag[1]}_${fileName}`] = text;
                    }
                    else {
                        console.warn(`Failed to fetch a resource. ${result.status} - ${result.statusText}\nThis inject tag was skipped.`);
                        writeStream.write(`<!-- ERROR! Failed to fetch "${injectTag[1]}". ${result.status} - ${result.statusText} -->`);
                    }
                }
            }
            writeStream.write(`${line.substring(charCount)}\n`);
        }
    }

}

/**
 * メイン関数
 */
async function main(): Promise<void> {
    /**
     * コマンドライン引数を確認する。
     * @param argIndex 確認する引数のインデクス番号（1つ目の引数は0、2つ目の引数は1、...）
     * @param errorMessage 引数が指定されていない場合のエラーメッセージ
     * @returns 引数が指定されていればtrue、指定されていなければfalseを返す。
     */
    function checkArgs(argIndex: number, errorMessage: string): boolean {
        if(process.argv[argIndex + 2] != undefined && process.argv[argIndex + 2].length > 0) return true;
        else {
            console.error(errorMessage);
            return false;
        }
    }

    if(checkArgs(0, "The repository name is not specified.") && checkArgs(1, "The template repository name is not specified.") && checkArgs(2, "The branch name of the template repository is not specified.")) {
        const readmeGenerator: ReadmeGenerator = new ReadmeGenerator(process.argv[2], process.argv[3], process.argv[4]);
        console.info("Generating README.md...");
        await readmeGenerator.generateReadme("../README_templates/en.md", "../README.md");
        console.info("Generating README_jp.md...");
        await readmeGenerator.generateReadme("../README_templates/jp.md", "../README_jp.md");
    }
    else process.exit(1);
}

main();