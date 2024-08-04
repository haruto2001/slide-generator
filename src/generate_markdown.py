from langchain_core.prompts import PromptTemplate
from langchain_openai import OpenAI


def main():
    template = "{instruction}"
    prompt = PromptTemplate.from_template(template)
    llm = OpenAI()
    llm_chain = prompt | llm
    instruction = (
    """
    I am trying to create slides using Marp.
    Please write markdown to create three simple slides as a sample.
    However, since the output will be converted directly to PDF, do not include any text unrelated to the slides.
    """
    )
    response = llm_chain.invoke(instruction)
    print(response)
    with open("samples/markdown/generated.md", "w") as f:
        f.write(response)


if __name__ == "__main__":
    main()